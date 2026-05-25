import 'package:flutter/material.dart';
import '../utils/app_language.dart';
import '../utils/app_strings.dart';
import '../utils/auth_service.dart';
import '../utils/score_service.dart';
import '../utils/responsive_helper.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  List<LeaderboardEntry> _entries = [];
  bool   _isLoading   = true;
  String _currentUser = '-';

  late AnimationController _animCtrl;
  late Animation<double>   _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn);
    _loadData();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final entries = await ScoreService().getLeaderboard();
    final user    = await AuthService().getCurrentUsername();
    if (mounted) {
      setState(() {
        _entries    = entries;
        _currentUser = user;
        _isLoading  = false;
      });
      _animCtrl.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppLanguage(),
      builder: (context, _) {
        final lang = AppLanguage().language;
        String s(String key) => AppStrings.get(key, lang);

        return Scaffold(
          backgroundColor: const Color(0xFF0D1B2A),
          body: Stack(
            children: [
              // ─── BACKGROUND gradient ──────────────────────────
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF0D1B2A),
                      Color(0xFF1B2D3E),
                      Color(0xFF0D3B1F),
                    ],
                  ),
                ),
              ),

              // ─── BINTANG DEKORATIF ────────────────────────────
              ...List.generate(20, (i) {
                final x = (i * 137.5) % MediaQuery.of(context).size.width;
                final y = (i * 97.3)  % MediaQuery.of(context).size.height;
                return Positioned(
                  left: x, top: y,
                  child: Icon(
                    Icons.star,
                    size: 4 + (i % 3) * 3.0,
                    color: Colors.white.withOpacity(0.08 + (i % 5) * 0.04),
                  ),
                );
              }),

              // ─── KONTEN UTAMA ─────────────────────────────────
              SafeArea(
                child: Column(
                  children: [
                    _buildHeader(s),
                    Expanded(
                      child: _isLoading
                          ? _buildLoading()
                          : _entries.isEmpty
                              ? _buildEmpty(s)
                              : FadeTransition(
                                  opacity: _fadeAnim,
                                  child: _buildContent(s),
                                ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── HEADER ─────────────────────────────────────────────────────
  Widget _buildHeader(String Function(String) s) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          ),
          const Spacer(),
          Column(
            children: [
              const Text(
                '🏆',
                style: TextStyle(fontSize: 28),
              ),
              Text(
                s('leaderboard_title'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              _animCtrl.reset();
              _loadData();
            },
            icon: const Icon(Icons.refresh_rounded, color: Colors.white70),
            tooltip: 'Refresh',
          ),
        ],
      ),
    );
  }

  // ─── LOADING ─────────────────────────────────────────────────────
  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.amber),
          SizedBox(height: 16),
          Text(
            'Memuat peringkat...',
            style: TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }

  // ─── EMPTY STATE ─────────────────────────────────────────────────
  Widget _buildEmpty(String Function(String) s) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🎮', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 16),
          Text(
            s('leaderboard_empty'),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            s('leaderboard_play_hint'),
            style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ─── KONTEN LEADERBOARD ──────────────────────────────────────────
  Widget _buildContent(String Function(String) s) {
    return RefreshIndicator(
      onRefresh: _loadData,
      color: Colors.amber,
      backgroundColor: const Color(0xFF1B2D3E),
      child: CustomScrollView(
        slivers: [
          // Podium Top 3
          SliverToBoxAdapter(child: _buildPodium(s)),

          // Spacer
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Header daftar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    s('leaderboard_all'),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 1,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_entries.length} ${s('leaderboard_players')}',
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // Daftar semua
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => _buildListItem(_entries[i], s),
              childCount: _entries.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  // ─── PODIUM TOP 3 ────────────────────────────────────────────────
  Widget _buildPodium(String Function(String) s) {
    final top3 = _entries.take(3).toList();

    // Data tiap slot podium (urutan tampil: kiri=silver, tengah=gold, kanan=bronze)
    // slot: [dataIndex, barHeight, color, medal]
    final slots = <Map<String, dynamic>>[
      // Slot KIRI  = rank 2 (perak)
      {
        'entry':  top3.length >= 2 ? top3[1] : null,
        'height': 100.0,
        'color':  const Color(0xFFC0C0C0),
        'medal':  '🥈',
      },
      // Slot TENGAH = rank 1 (emas)
      {
        'entry':  top3.isNotEmpty ? top3[0] : null,
        'height': 130.0,
        'color':  const Color(0xFFFFD700),
        'medal':  '🥇',
      },
      // Slot KANAN  = rank 3 (perunggu)
      {
        'entry':  top3.length >= 3 ? top3[2] : null,
        'height': 80.0,
        'color':  const Color(0xFFCD7F32),
        'medal':  '🥉',
      },
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Text(
            s('leaderboard_top3'),
            style: const TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: slots.map((slot) {
              final entry  = slot['entry']  as LeaderboardEntry?;
              final height = slot['height'] as double;
              final color  = slot['color']  as Color;
              final medal  = slot['medal']  as String;

              // Jika tidak ada pemain untuk slot ini, tampilkan kotak kosong
              if (entry == null) return const SizedBox(width: 92);

              final isMe = entry.username == _currentUser;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Medal emoji
                    Text(medal, style: const TextStyle(fontSize: 24)),
                    const SizedBox(height: 4),

                    // Avatar lingkaran
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color.withOpacity(0.2),
                        border: Border.all(
                          color: isMe ? Colors.greenAccent : color,
                          width: isMe ? 2.5 : 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          entry.username[0].toUpperCase(),
                          style: TextStyle(
                            color: isMe ? Colors.greenAccent : color,
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Username
                    SizedBox(
                      width: 80,
                      child: Text(
                        entry.username,
                        style: TextStyle(
                          color: isMe ? Colors.greenAccent : Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Skor
                    Text(
                      '${entry.totalScore} pts',
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Podium bar
                    Container(
                      width: 80,
                      height: height,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            color.withOpacity(0.55),
                            color.withOpacity(0.2),
                          ],
                        ),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                        border: Border.all(color: color.withOpacity(0.35)),
                      ),
                      child: Center(
                        child: Text(
                          '#${entry.rank}',
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─── ITEM DAFTAR ─────────────────────────────────────────────────
  Widget _buildListItem(LeaderboardEntry entry, String Function(String) s) {
    final isMe = entry.username == _currentUser;
    final isTop = entry.rank <= 3;

    final rankColors = {
      1: const Color(0xFFFFD700),
      2: const Color(0xFFC0C0C0),
      3: const Color(0xFFCD7F32),
    };
    final rankColor = rankColors[entry.rank] ?? Colors.white38;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isMe
            ? Colors.green.withOpacity(0.12)
            : Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isMe
              ? Colors.greenAccent.withOpacity(0.4)
              : isTop
                  ? rankColor.withOpacity(0.3)
                  : Colors.white.withOpacity(0.06),
          width: isMe ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Rank
            SizedBox(
              width: 36,
              child: isTop
                  ? Text(
                      ['🥇', '🥈', '🥉'][entry.rank - 1],
                      style: const TextStyle(fontSize: 22),
                    )
                  : Text(
                      '#${entry.rank}',
                      style: const TextStyle(
                        color: Colors.white38,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
            ),
            const SizedBox(width: 8),

            // Avatar bulat
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isMe ? Colors.green : Colors.blue).withOpacity(0.2),
                border: Border.all(
                  color: isMe ? Colors.greenAccent : Colors.white24,
                ),
              ),
              child: Center(
                child: Text(
                  entry.username[0].toUpperCase(),
                  style: TextStyle(
                    color: isMe ? Colors.greenAccent : Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Username + info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        entry.username,
                        style: TextStyle(
                          color: isMe ? Colors.greenAccent : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Kamu',
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${entry.gamesPlayed}x main • ${entry.percentage}% akurasi',
                    style: const TextStyle(color: Colors.white38, fontSize: 11),
                  ),
                ],
              ),
            ),

            // Skor total
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${entry.totalScore}',
                  style: TextStyle(
                    color: isTop ? rankColor : Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                ),
                const Text(
                  'pts',
                  style: TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
