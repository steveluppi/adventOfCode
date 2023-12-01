cd $1
shift
npx nodemon -w main.rb --exec "ruby main.rb $@"
