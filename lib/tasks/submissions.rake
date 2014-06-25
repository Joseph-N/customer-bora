namespace :submissions do
  desc "Import earlier submissions"
  task :import =>  [:environment] do


    CSV.foreach("data/product-submissions.csv") do |row|
      user = User.find_by phone: row[1].insert(0,"+")

      if user
        puts "Found User: #{user.name}"
        submissions = row[0].split(',')
        if submissions.size > 1
          puts "Found multiple submissions"
          for submission in submissions
            details = submission.split('#')
            name = details[0]
            serial = details[1]
            date = row[2].to_date

            puts "name: #{name} serial: #{serial} date: #{date}"

            begin
              user.submissions.create!(name: name, serial_no: serial, created_at: date, updated_at: date)
              puts "Successfully created record"
            rescue Exception => e
              puts "Serial no already submitted"
              puts e.message
            end
          end
        else
          details = row[0].split('#')
          name = details[0]
          serial = details[1]
          date = row[2].to_date

          puts "name: #{name} serial: #{serial} date: #{date}"

          begin
            user.submissions.create!(name: name, serial_no: serial, created_at: date, updated_at: date)
            puts "Successfully created record"
          rescue Exception => e
            puts "Serial no already submitted"
            puts e.message
          end
        end
      else
        puts "No user found with phone: #{row[1]}"
      end
    end
  end
end