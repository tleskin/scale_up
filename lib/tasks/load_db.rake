namespace :load_db do
  desc "Load pre-generated PG data into Dev db"
  task :load => ["db:drop", "db:create"] do
    load_cmd = "heroku pg:backups restore 'https://localhost:8000/backup.dump' postgres://zbbcfushgatfct:cXH5WfpZHWTIhpSgVQE8w6vzt1@ec2-107-22-175-206.compute-1.amazonaws.com:5432/d2b04hmm3kubgv"
    puts "will load Data dump into local PG database with command:"
    puts load_cmd
    system(load_cmd)
  end
end
