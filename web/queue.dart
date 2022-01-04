import 'dart:html';

void main() {
  print("Reading queue initialized");

  InputElement inputBox = querySelector(".inputField input") as InputElement;
  ButtonElement addButton =
      querySelector(".inputField button") as ButtonElement;
  UListElement readingListElement =
      querySelector(".readingList") as UListElement;
  SpanElement numUnreadElement = querySelector(".numUnread") as SpanElement;

  ReadingQueue queue = ReadingQueue(); // todo: pull this from server
  queue.render(readingListElement, numUnreadElement);

  addButton.onClick.listen((_) {
    var newLink = inputBox.value;
    if (newLink != null && newLink.isNotEmpty) {
      queue.addLink(newLink);
      inputBox.value = "";
    }

    queue.render(readingListElement, numUnreadElement);
  });

  inputBox.onKeyUp.listen((keyboardEvent) {
    var enteredValue = inputBox.value;
    if (enteredValue != null && enteredValue.isNotEmpty) {
      addButton.classes.add("active");
      var keyEvent = KeyEvent.wrap(keyboardEvent);
      if (keyEvent.keyCode == KeyCode.ENTER) {
        addButton.classes.remove("active");
        addButton.click();
      }
    } else {
      addButton.classes.remove("active");
    }
  });
}

class ReadingQueue {
  List<String> links; // todo: integrate with backend datatypes (document?)
  // todo: intelligent/ remembered sorting of items

  ReadingQueue() : links = [];

  bool addLink(String link) {
    if (links.contains(link)) {
      return false;
    }
    links.add(link);
    return true;
  }

  bool removeLink(String link) {
    return links.remove(link);
  }

  void render(UListElement listElement, SpanElement numUnreadElement) {
    numUnreadElement.text = links.length.toString();
    listElement.children = links.map((link) {
      var linkElement = LIElement();
      linkElement.text = link;

      var deletionSpan = SpanElement();
      deletionSpan.classes.add("icon");
      deletionSpan.setInnerHtml('<i class="fas fa-check"></i>');
      deletionSpan.onClick.listen((_) {
        removeLink(link);
        render(listElement, numUnreadElement);
      });

      linkElement.children.add(deletionSpan);
      return linkElement;
    }).toList();
  }
}
