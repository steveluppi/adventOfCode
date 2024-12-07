cd $1
echo $pwd
shift
npx nodemon -w main.rb --exec "ruby main.rb $@"
