HOW TO
===

1. docker run -d -p <puerto>:8080 -v <comics folder>:/comics --name=yacserver muallin/yacreaderlibrary
2. docker exec yacserver YACReaderLibraryServer create-library <library-name> /comics

