## Compiling Flow to BuckleScript to compare its perf against js_of_ocaml

```
npm install
ocamllex lexer_flow.mll
bsc -bs-files *.ml *.mli
node testParser.js
```

BS competitive in perf. To try the Flow version, revert the files here to master (keep `testParser.js`). In this current directory, `make js` (might need to clean up some artifacts as per instruction), then uncomment L2 and comment out L4 in `testParser.js`.
