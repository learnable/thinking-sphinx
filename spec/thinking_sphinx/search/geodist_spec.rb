require 'spec_helper'

describe ThinkingSphinx::Search::Geodist do
  let(:inquirer)   { ThinkingSphinx::Search::Inquirer.new search }
  let(:search)     {
    double('search', :query => '', :options => {}, :offset => 0, :per_page => 5)
  }
  let(:config)     {
    double('config', :connection => connection, :indices => [],
      :preload_indices => true)
  }
  let(:connection) { double('connection') }
  let(:sphinx_sql) { double('sphinx select', :to_sql => '') }

  before :each do
    ThinkingSphinx::Configuration.stub! :instance => config
    Riddle::Query.stub! :connection => connection
    Riddle::Query::Select.stub! :new => sphinx_sql

    sphinx_sql.stub! :from => sphinx_sql, :offset => sphinx_sql,
      :limit => sphinx_sql, :where => sphinx_sql
    connection.stub(:query).and_return([], [])
  end

  describe '#populate' do
    it "adds the geodist function when given a :geo option" do
      search.options[:geo] = [0.1, 0.2]

      sphinx_sql.should_receive(:values).
        with('GEODIST(0.1, 0.2, lat, lng) AS geodist').
        and_return(sphinx_sql)

      inquirer.populate
    end

    it "doesn't add anything if :geo is nil" do
      search.options[:geo] = nil

      sphinx_sql.should_not_receive(:values)

      inquirer.populate
    end
  end
end