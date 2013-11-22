var exec=require('child_process').exec;

exports.index = function(req, res){
  if(req.session && req.session.login && req.session.login=='true'){
    showModules(req, res);
  }else if(req.body.username && req.body.passwd){
    if(req.body.username == 'admin' && req.body.passwd != '' ){
      var pwd=req.body.passwd.replace(/'/g, '\\\'\'');
      var shadow='/etc/shadow';
      cmd='openssl passwd -1 -salt $(grep root ' + shadow + ' | cut -f2 -d\':\'|cut -f3 -d\'$\') \'' + pwd + '\' | grep -f - ' + shadow + ' | grep root -c';
      var child=exec(cmd, function(err, stdout, stderr){
        if(stderr){
          console.log('exec error: ' + stderr);
          res.send('Internal error');
        }else{
          if(stdout.trim() == '1'){
            req.session.login='true';
            showModules(req, res);
          }else{
            login(req, res);
          }
        }
      });
    }else{
      login(req, res);
    }
  }else{
    login(req, res);
  }
}

function showModules(req, res){
  cmd='../list_modules.bash';
  var child=exec(cmd,function(err, stdout, stderr){
    if(err || stderr){
       console.log('exec error: ' + err + " " + stderr);
       res.render('index', {title: 'Module Manager', error: stderr});
    }else{
      var result=stdout.split("\n");
      var modules=[];
      for(i=0;i<result.length-1;i++){
        var line=result[i].split("\t");
        var module={};
        module.name=line[0];
        module.path=line[1];
        module.usage=line[2].split("|");
        modules.push(module);
      }
      res.render('index', { title: 'Module Manager', modules: modules, login: 'true' });
    }
  });
}

function login(req, res){
  res.render('index', {title: 'Module Manager', login: 'false'})
}
