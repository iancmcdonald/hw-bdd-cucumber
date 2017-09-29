# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  Movie.delete_all
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  expect(page.body.index(e1)).to be < page.body.index(e2)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(', ').each do |rating|
    if uncheck == 'un'
      uncheck("ratings_#{rating}")
    else
      check("ratings_#{rating}")
    end
  end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  num_rows = page.all('table#movies tr').count
  expect(num_rows).to eq Movie.count + 1
end

Then /I should (not )?see movies with the following ratings: (.*)/ do |not_see, rating_list|
  ratings = rating_list.split(', ')
  title_list = Movie.where(rating: ratings).pluck('title')
  title_list.each do |title|
    if not_see == 'not '
      step "I should not see \"#{title}\""
    else
      step "I should see \"#{title}\""
    end
  end
end
