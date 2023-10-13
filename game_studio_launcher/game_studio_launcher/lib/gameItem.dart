class GameItem{
   String name;
  String description;
  String path;
  String imagePath;
  bool isVisible;

  GameItem(
      {required this.name,
      required this.description,
      required this.path,
      required this.imagePath,
      required this.isVisible});
}