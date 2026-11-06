
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../coach/data/services/coach_request_service.dart';
import '../../../coach/data/services/coach_search_service.dart';
import '../../../coach/domain/coach_profile.dart';
import '../../../coach/domain/coach_request.dart';
import '../../../coach/domain/coach_search_result.dart';

class MeusCoachesSection extends StatefulWidget {
  final VoidCallback onLinkCoachTap;

  const MeusCoachesSection({
    super.key,
    required this.onLinkCoachTap,
  });

  @override
  State<MeusCoachesSection> createState() =>
      _MeusCoachesSectionState();
}

class _MeusCoachesSectionState extends State<MeusCoachesSection> {
  final CoachRequestService _requestService =
      CoachRequestService();

  final CoachSearchService _searchService =
      CoachSearchService();

  late Future<List<_CoachRequestDisplay>> _requestsFuture;

  @override
  void initState() {
    super.initState();
    _requestsFuture = _loadRequests();
  }

  Future<List<_CoachRequestDisplay>> _loadRequests() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return [];
    }

    final requests =
        await _requestService.getRequestsForStudent(user.uid);

    final results = await Future.wait(
      requests.map((request) async {
        final coach = await _searchService.searchByCoachId(
          request.coachId,
        );

        return _CoachRequestDisplay(
          request: request,
          coach: coach,
        );
      }),
    );

    return results;
  }

  void _refreshRequests() {
    setState(() {
      _requestsFuture = _loadRequests();
    });
  }

  String _specialtyName(CoachSpecialty specialty) {
    switch (specialty) {
      case CoachSpecialty.training:
        return 'Treinamento';
      case CoachSpecialty.nutrition:
        return 'Nutrição';
    }
  }

  Widget _buildRequestCard(_CoachRequestDisplay item) {
    final request = item.request;
    final coach = item.coach;

    final isPending =
        request.status == CoachRequestStatus.pending;
    final isAccepted =
        request.status == CoachRequestStatus.accepted;

    final statusColor = isPending
        ? Colors.orange
        : isAccepted
            ? const Color(0xFF20C779)
            : const Color(0xFFFF1010);

    final statusText = isPending
        ? 'Pendente'
        : isAccepted
            ? 'Vinculado'
            : 'Recusado';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF303030),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFF383838),
            backgroundImage: coach?.photoUrl != null &&
                    coach!.photoUrl!.isNotEmpty
                ? NetworkImage(coach.photoUrl!)
                : null,
            child: coach?.photoUrl == null ||
                    coach!.photoUrl!.isEmpty
                ? const Icon(
                    Icons.person,
                    color: Colors.white70,
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coach?.name ?? 'Coach não encontrado',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  request.specialties
                      .map(_specialtyName)
                      .join(' • '),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: statusColor,
                      size: 9,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                if (isPending) ...[
                  const SizedBox(height: 4),
                  const Text(
                    'Aguardando aprovação do Coach.',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                  ),
                ],
                if (request.status ==
                    CoachRequestStatus.rejected) ...[
                  const SizedBox(height: 4),
                  const Text(
                    'O Coach recusou esta solicitação.',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.chevron_right,
            color: Colors.white38,
          ),
        ],
      ),
    );
  }

  Widget _buildRequestsContent() {
    return FutureBuilder<List<_CoachRequestDisplay>>(
      future: _requestsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFF1010),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Não foi possível carregar seus Coaches.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          );
        }

        final requests = snapshot.data ?? [];

        if (requests.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF242424),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.person_search_rounded,
                  color: Colors.white54,
                  size: 34,
                ),
                SizedBox(height: 10),
                Text(
                  'Nenhum Coach vinculado',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Encontre um profissional e solicite '
                  'uma conexão para começar.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          );
        }

        final pending = requests.where(
          (item) =>
              item.request.status == CoachRequestStatus.pending,
        ).toList();

        final accepted = requests.where(
          (item) =>
              item.request.status == CoachRequestStatus.accepted,
        ).toList();

        final rejected = requests.where(
          (item) =>
              item.request.status == CoachRequestStatus.rejected,
        ).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (accepted.isNotEmpty) ...[
              const Text(
                'COACHES VINCULADOS',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 10),
              ...accepted.map(_buildRequestCard),
              const SizedBox(height: 8),
            ],
            if (pending.isNotEmpty) ...[
              const Text(
                'SOLICITAÇÕES PENDENTES',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 10),
              ...pending.map(_buildRequestCard),
              const SizedBox(height: 8),
            ],
            if (rejected.isNotEmpty) ...[
              const Text(
                'SOLICITAÇÕES RECUSADAS',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 10),
              ...rejected.map(_buildRequestCard),
            ],
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF303030),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.groups_rounded,
                color: Color(0xFFFF1010),
                size: 22,
              ),
              SizedBox(width: 10),
              Text(
                'Meus Coaches',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Conecte-se aos profissionais que acompanham '
            'seu treinamento e sua alimentação.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          _buildRequestsContent(),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: widget.onLinkCoachTap,
              icon: const Icon(Icons.add),
              label: const Text('Vincular a um Coach'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF1010),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton.icon(
              onPressed: _refreshRequests,
              icon: const Icon(
                Icons.refresh,
                color: Colors.white54,
                size: 17,
              ),
              label: const Text(
                'Atualizar solicitações',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CoachRequestDisplay {
  final CoachRequest request;
  final CoachSearchResult? coach;

  const _CoachRequestDisplay({
    required this.request,
    required this.coach,
  });
}
