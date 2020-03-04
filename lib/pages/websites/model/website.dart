class Website {
  final String category;
  final String iconPath;
  final String label;
  final String link;

  Website({this.category, this.iconPath, this.label, this.link});

  factory Website.fromWebsite(Website website) {
    return Website(
        category: website.category,
        iconPath: website.iconPath,
        label: website.label,
        link: website.link);
  }
}
