## Compiling Flow to BuckleScript to compare its perf against js_of_ocaml

To try it yourself, have OCaml ready.
```sh
# gonna do `make js` to get the js_of_ocaml compiled js first
git checkout master
make js
# now, get the BuckleScript compiled js
git checkout BS
# yeah for real, installing BS through npm works. Isn't that amazing
npm install
ocamllex lexer_flow.mll
bsc -bs-files *.ml *.mli
# bench!
node testParser.js
```
