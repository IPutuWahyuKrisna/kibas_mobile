import 'package:kibas_mobile/src/features/users/features/complaint_users/domain/entities/post_complaint_entity.dart';

class PostComplaintModel extends PostComplaintEntity {
  const PostComplaintModel({
    required super.image,
    required super.complaint,
  });

  Map<String, dynamic> toJson() {
    return {"complaint": complaint, "image": image};
  }
}
