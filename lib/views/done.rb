require 'bundler'
Bundler.require


class Done

  def recommencer

    puts "Try again y/n?"

    user_choice = gets.chomp

    if user_choice == "y"
      Index.new.choix
    else
      puts "aurevoir"
    end


  end

end
