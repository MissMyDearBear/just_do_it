class Task {
  final String title;

  final String ownName;

  final int state;

  final String time;

  final String detail;

  Task(this.title, this.ownName, this.state, this.time, this.detail);

  // 反序列化方法
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      json['title'] ?? "",
      json['ownName'] ?? "",
      json['state'] ?? 0,
      json['time'] ?? "",
      json['detail'] ?? "",
    );
  }
}
