// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    width: 100
    height: 62

    function getAnswers(model, idq){
        var db = openDatabaseSync("maeya", "1.0", "bookmarks",1000);
        db.readTransaction(
                    function(tx) {
                        var rs = tx.executeSql('select * from Bookmarks ');
                        q.text = rs.rows.item(0).q;
                    }
                    )
    }

    ListView {

    }
}
