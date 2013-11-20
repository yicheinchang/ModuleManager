var exec=require('child_process').exec;
var Convert = require('ansi-to-html');

/*
 * GET home page.
 */

exports.index = function(req, res){
  cmd='../list_modules.bash';
  var child=exec(cmd,function(err, stdout, stderr){
    if(err || stderr){
       console.log('exec error: ' + err + " " + stderr);
       res.render('index', {title: 'Module Manager', content: stderr});
    }else{
      var result=stdout.split("\n");
      var convert=new Convert();
      //console.log(result);
      var modules=[];
      for(i=0;i<result.length-1;i++){
        var line=result[i].split("\t"); //=convert.toHtml(result[i]);
        var module={};
        module.name=line[0];
        module.path=line[1];
        module.usage=line[2].split("|");
        modules.push(module);
      }
      //console.log(modules);
      res.render('index', { title: 'Module Manager', content: modules });
    }
  });
};
