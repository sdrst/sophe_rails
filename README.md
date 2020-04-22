# README

This is the ruby on rails backend for SOPHE

# Helpful Materials
Ruby stores data (datastructures) as active records

### Migrations
Migrations specify the structure of each active record within the sql database.
Below is an example migration for a person.
It has two fields (columns) called name and birthplace that hold strings.
It also has a field for the number of friends (stored as an integer).
You should never directly create the migration file yourself. You should instead 
run the command `rails g migration <migration_name>`. After you write the migration, run the commands
`rake db:migrate` and `rake db:migrate RAILS_ENV=test`, which update the development and test
database with the new information. If you need to edit a table, create a new migration that edits
a existing table rather rewrite the migration that created the table

```ruby
class CreatePerson < ActiveRecord::Migration[6.0]
  def change
    create_table :people do |t|
      t.string :name
      t.string :birthplace
      t.integer :num_of_friends

      t.timestamps
    end
  end
end
```
For more information:
https://edgeguides.rubyonrails.org/active_record_migrations.html

### Models
Each active record also have a model file, which specifies additional
information besides the field names and types (e.g. validation and custom methods).
Essentially, migrations define the attributes of a class while models define
the methods of that class. They are stored in `app/models`. Here is an example model for
person. This model ensures that no active record can be saved without `name` defined. If you
were to call the method `say_something_funny` on a person object, it would return
`"why did the chicken cross the round"`. FYI, you don't need to explicitly stat `return` in ruby for a function
to return something.
```ruby
class Person < ApplicationRecord
  validates :name, presence: true
  def say_something_funny
    "why did the chicken cross the round"
  end
end
```
For more information:
https://guides.rubyonrails.org/active_model_basics.html

## Controllers
In order to expose each of the data objects to the outside world (REST), we need
to take advantage of the controller. Each controller has a set of methods that correspond
to a number of routes.
 
```ruby
class PeopleController < ApplicationController
  protect_from_forgery

  def index
    render json: Person.all
  end

  def show
    render json: person
  end

  def create
    render json: Lab.create!(person_params)
  end

  def update
    person.update!(person_params)
    render json: lab
  end

  def destroy
    render json: person.destroy!
  end

  private

  def person
    Person.find(params[:id])
  end

  def pearson_params
    params.require(:person).permit(
      :name, 
      :birthplace, 
      :num_of_friends
    )
  end
end
```
If you make a GET or POST request to `/people`, the methods `index` and `create`
are called respectively. A GET, PUT (PATCH), or DELETE request to `/person/1` will call the method show, update
and destroy, respectively. By now, you should have realized the method `def person`. When this is called
it returns a pearson active record with id specified. In the above examples, that id is 1. 
(I suggest that you play around with the params object and see how it works). There is also
another method called `person_params`, which validates the params (body) passed to the route
during the HTTP request. In this case, only something like would be accepted:
```json
{
  "person": {
    "name": <NAME HERE>,
    "birthplace": <BIRTHPLACE HERE>,
    "num_of_friends": <NUM_OF_FRIENDS>
  }
}
```
person_params would return this:
```ruby
{
  name: <NAME HERE>,
  birthplace: <BIRTHPLACE HERE>,
  num_of_friends: <NUM_OF_FRIENDS>
}
```
For more information:
https://guides.rubyonrails.org/action_controller_overview.html

### How to run the test suite

Sophe Rails uses Rspec for testings. In order to run tests, install the appropriate
gems via `bundle install` and execute `rspec` in the main directory.

### Rails Console

By using `rails c`, you are able to play around with active records yourself