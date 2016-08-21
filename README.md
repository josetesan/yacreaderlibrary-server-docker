HOW TO
===
```
1. docker run -d -p <port>:8080 -v <comics folder>:/comics --name=yacserver muallin/yacreaderlibrary-server-docker
2. docker exec yacserver YACReaderLibraryServer create-library <library-name> /comics
```

