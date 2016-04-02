# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    #Adding movies direclty with the help of Activerecord
    Movie.create(movie)
  end  
end

Then /^the director of "([^"]*)" should be "([^"]*)"$/ do |title, director|
  movie = Movie.find_by_title(title)
  movie.director.should == director
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|  
  regexp = /#{e1}.*#{e2}/m  
  expect(page.body).to match(regexp)
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list| 
  rating_list.split(/,\s*/).each { |rating|  
    if uncheck
      uncheck "ratings_#{rating}" 
    else
      check "ratings_#{rating}"
    end
  }
end

Then /I should see all the movies/ do
  #1 extra row for table header so taking tbody
  page.should have_css "table#movies tbody tr", :count => Movie.count
end