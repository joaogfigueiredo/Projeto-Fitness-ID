
import 'package:flutter/material.dart';

class MeusCoachesSection extends StatelessWidget {
  final VoidCallback onLinkCoachTap;

  const MeusCoachesSection({
    super.key,
    required this.onLinkCoachTap,
  });

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

          Container(
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
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onLinkCoachTap,
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
        ],
      ),
    );
  }
}
