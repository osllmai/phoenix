import '../providers/document.dart';
import 'document_dto.dart';

DocStatus statusFromApi(String status) {
  switch (status) {
    case 'converting':
      return DocStatus.converting;
    case 'ready':
      return DocStatus.converted;
    case 'failed':
      return DocStatus.failed;
    default:
      return DocStatus.queued;
  }
}

(DocKind, String) _kindFor(String title) {
  final ext = title.contains('.') ? title.split('.').last.toLowerCase() : '';
  switch (ext) {
    case 'pdf':
      return (DocKind.pdf, 'PDF');
    case 'doc':
    case 'docx':
    case 'ppt':
    case 'pptx':
    case 'xls':
    case 'xlsx':
      return (DocKind.office, ext.toUpperCase());
    case 'png':
    case 'jpg':
    case 'jpeg':
      return (DocKind.image, 'IMG');
    case 'wav':
    case 'mp3':
    case 'm4a':
      return (DocKind.audio, 'AUDIO');
    case 'html':
    case 'htm':
      return (DocKind.web, 'WEB');
    default:
      return (DocKind.office, ext.isEmpty ? 'FILE' : ext.toUpperCase());
  }
}

String _meta(DateTime createdAt) {
  final d = createdAt.toLocal();
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${months[d.month - 1]} ${d.day}';
}

PhoenixDocument fromListItem(DocumentListItemDto dto) {
  final (kind, badge) = _kindFor(dto.title);
  return PhoenixDocument(
    id: dto.id.toString(),
    title: dto.title,
    kind: kind,
    status: statusFromApi(dto.status),
    meta: _meta(dto.createdAt),
    badge: badge,
  );
}

PhoenixDocument fromDetail(DocumentDetailDto dto) {
  final (kind, badge) = _kindFor(dto.title);
  return PhoenixDocument(
    id: dto.id.toString(),
    title: dto.title,
    kind: kind,
    status: statusFromApi(dto.status),
    meta: _meta(dto.createdAt),
    badge: badge,
    markdown: dto.markdown.isNotEmpty ? dto.markdown : dto.error,
  );
}
