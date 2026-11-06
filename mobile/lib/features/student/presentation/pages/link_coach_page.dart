
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../coach/data/services/coach_request_service.dart';
import '../../../coach/data/services/coach_search_service.dart';
import '../../../coach/domain/coach_profile.dart';
import '../../../coach/domain/coach_search_result.dart';

class LinkCoachPage extends StatefulWidget {
  const LinkCoachPage({super.key});

  @override
  State<LinkCoachPage> createState() => _LinkCoachPageState();
}

class _LinkCoachPageState extends State<LinkCoachPage> {
  final TextEditingController _coachIdController =
      TextEditingController();

  final CoachSearchService _coachSearchService =
      CoachSearchService();

  final CoachRequestService _coachRequestService =
      CoachRequestService();

  CoachSearchResult? _coachResult;

  final Set<CoachSpecialty> _selectedSpecialties = {};

  bool _isSearching = false;
  bool _isSendingRequest = false;
  bool _hasSearched = false;

  String? _errorMessage;

  @override
  void dispose() {
    _coachIdController.dispose();
    super.dispose();
  }

  // Pesquisa um Coach pelo CoachID.
  Future<void> _searchCoach() async {
    final coachId = _coachIdController.text.trim();

    if (coachId.isEmpty) {
      setState(() {
        _errorMessage = 'Digite o CoachID para pesquisar.';
        _coachResult = null;
        _hasSearched = true;
        _selectedSpecialties.clear();
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _hasSearched = false;
      _errorMessage = null;
      _coachResult = null;
      _selectedSpecialties.clear();
    });

    try {
      final result =
          await _coachSearchService.searchByCoachId(coachId);

      if (!mounted) return;

      setState(() {
        _coachResult = result;
        _hasSearched = true;

        if (result == null) {
          _errorMessage =
              'Nenhum Coach ativo foi encontrado com esse código.';
        }
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage =
            'Não foi possível realizar a pesquisa. Tente novamente.';
        _hasSearched = true;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    }
  }

  // Envia a solicitação de vínculo ao Firestore.
  Future<void> _sendRequest() async {
    final user = FirebaseAuth.instance.currentUser;
    final coach = _coachResult;

    if (user == null || coach == null) {
      return;
    }

    if (_selectedSpecialties.isEmpty || _isSendingRequest) {
      return;
    }

    setState(() {
      _isSendingRequest = true;
    });

    try {
      await _coachRequestService.createRequest(
        studentId: user.uid,
        coachId: coach.coachId,
        specialties: _selectedSpecialties.toList(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Solicitação enviada! Aguarde a aprovação do Coach.',
          ),
          backgroundColor: Color(0xFF20C779),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível enviar a solicitação. Tente novamente.',
          ),
          backgroundColor: Color(0xFFFF1010),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSendingRequest = false;
        });
      }
    }
  }

  // Seleciona ou remove uma especialidade.
  void _toggleSpecialty(CoachSpecialty specialty) {
    setState(() {
      if (_selectedSpecialties.contains(specialty)) {
        _selectedSpecialties.remove(specialty);
      } else {
        _selectedSpecialties.add(specialty);
      }
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

  // Card de seleção de especialidade.
  Widget _buildSpecialtyCard(CoachSpecialty specialty) {
    final isSelected = _selectedSpecialties.contains(specialty);

    return GestureDetector(
      onTap: _isSendingRequest
          ? null
          : () => _toggleSpecialty(specialty),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF351414)
              : const Color(0xFF242424),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFF1010)
                : const Color(0xFF303030),
          ),
        ),
        child: Row(
          children: [
            Icon(
              specialty == CoachSpecialty.training
                  ? Icons.fitness_center
                  : Icons.restaurant,
              color: const Color(0xFFFF1010),
              size: 24,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                _specialtyName(specialty),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Checkbox(
              value: isSelected,
              activeColor: const Color(0xFFFF1010),
              onChanged: _isSendingRequest
                  ? null
                  : (_) => _toggleSpecialty(specialty),
            ),
          ],
        ),
      ),
    );
  }

  // Exibe os dados do Coach encontrado.
  Widget _buildCoachResult() {
    final coach = _coachResult!;

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
          Row(
            children: [
              CircleAvatar(
                radius: 27,
                backgroundColor: const Color(0xFF303030),
                backgroundImage: coach.photoUrl != null &&
                        coach.photoUrl!.isNotEmpty
                    ? NetworkImage(coach.photoUrl!)
                    : null,
                child: coach.photoUrl == null ||
                        coach.photoUrl!.isEmpty
                    ? const Icon(
                        Icons.person,
                        color: Colors.white70,
                        size: 28,
                      )
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coach.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      coach.coachId,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.verified,
                color: Color(0xFF20C779),
                size: 23,
              ),
            ],
          ),

          const SizedBox(height: 24),

          const Text(
            'Especialidades disponíveis',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          ...coach.specialties.map(_buildSpecialtyCard),

          const SizedBox(height: 8),

          const Text(
            'Selecione as áreas em que deseja receber '
            'acompanhamento deste profissional.',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 20),

          // Botão de envio da solicitação.
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedSpecialties.isEmpty ||
                      _isSendingRequest
                  ? null
                  : _sendRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF1010),
                disabledBackgroundColor: const Color(0xFF424242),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSendingRequest
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Enviar solicitação',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text(
          'Vincular a um Coach',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Encontre seu Coach',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Digite o CoachID disponibilizado pelo profissional '
                'para encontrar o perfil e solicitar uma conexão.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'COACH ID',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: _coachIdController,
                textCapitalization: TextCapitalization.characters,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Ex.: FIT-XXXXXXXX',
                  hintStyle: const TextStyle(
                    color: Colors.white38,
                  ),
                  filled: true,
                  fillColor: const Color(0xFF191919),
                  prefixIcon: const Icon(
                    Icons.fingerprint,
                    color: Color(0xFFFF1010),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xFF303030),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xFF303030),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xFFFF1010),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSearching ? null : _searchCoach,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF1010),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSearching
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Pesquisar Coach',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: 20),
                Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Color(0xFFFF5555),
                    fontSize: 13,
                  ),
                ),
              ],

              if (_coachResult != null) ...[
                const SizedBox(height: 28),
                _buildCoachResult(),
              ],

              if (!_hasSearched && _coachResult == null) ...[
                const SizedBox(height: 35),
                const Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.person_search_rounded,
                        color: Color(0xFF555555),
                        size: 55,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'O perfil do Coach aparecerá aqui.',
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
