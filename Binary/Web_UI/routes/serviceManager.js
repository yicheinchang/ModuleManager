var exec=require('child_process').exec;
var Convert = require('ansi-to-html');

/*
 * GET home page.
 */

exports.action = function(req, res){
  var path=req.body.module_path;
  var act=req.body.module_action;
  var cmd=path +'/shell/module.rc ' + act;
  //res.send("Success:" + cmd);
  var br='<br />';
  var child=exec(cmd,function(err, stdout, stderr){
    if(err || stderr){
       console.log('exec error: ' + err + " " + stderr);
       res.send('Command: ' + cmd + br + br + 'Error: ' + err + br + br + stderr);
    }else{
      var convert = new Convert()
      res.send('Command: ' + cmd + br +  br + convert.toHtml(stdout));
    }
  });
};
