class ServerHealth {
  const ServerHealth({required this.reachable, this.service = ''});

  const ServerHealth.unreachable() : reachable = false, service = '';

  factory ServerHealth.fromJson(Map<String, dynamic> json) => ServerHealth(
        reachable: (json['status'] as String?) == 'ok',
        service: (json['service'] as String?) ?? '',
      );

  final bool reachable;
  final String service;
}
