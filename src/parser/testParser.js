var fs = require('fs');
// var parser = require('./flow_parser');
// var parser = require('babylon');
var parser = require('./flow_parser_js');

var content = fs.readFileSync('parser_flow.js', {encoding: 'utf8'});

var now = Date.now();
var tree = parser.parse(content, {});
console.log(Date.now() - now);





// // for JSC
//
// var parser = require('./flow_parser');
// // var parser = require('babylon');
// // var parser = require('./flow_parser_js');
//
// var content = '';
// var i = 0;
// while (i < 520) {
//   // fuck
//   content += readline();
//   i++;
// }
//
// var now = Date.now();
// var tree = parser.parse(content, {});
// print(tree);
// print(Date.now() - now);
