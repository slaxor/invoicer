//=require 'lib/markitup/jquery.markitup.js'
pdfSettings = {
  markupSet: [
    {name:'bold', key:'b', openWith:'<b>', closeWith:'</b>'},
    {name:'italic', key:'i', openWith:'<i>', closeWith:'</i>'}
  ]
}
$('textarea').markItUp(pdfSettings)

