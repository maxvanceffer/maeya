import Qt 4.7 // to target S60 5th Edition or Maemo 5

XmlListModel {
//    source: "https://translate.yandex.net/api/v1.5/tr/getLangs?key=" + api_key + "&ui=en";
    query: "/Langs/langs/Item"

    XmlRole { name: "title"; query: "@value/string()" }
    XmlRole { name: "key"; query: "@key/string()" }
}
