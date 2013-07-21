require 'test_helper'

class RoundTest < ActiveSupport::TestCase
  should have_many :availabilities
  should have_many :tokens
  should have_many :redemptions

  should 'happen periodically'
  should 'run availability checks once and only once' do
    @round = FactoryGirl.create :round
    @service = FactoryGirl.create :service
    @instance = FactoryGirl.create :instance, service: @service
    FactoryGirl.create(:instance, team: FactoryGirl.create(:legitbs), service: @service)
    @shell = stub 'shell process', status: 0, output: 'okay'
    ShellProcess.stubs(:new).returns(@shell)

    refute @round.availability_checks_done?

    @round.check_availability

    assert @round.availability_checks_done?

    @round.check_availability
  end

  context 'class methods' do
    should 'get the current round' do
      r1 = FactoryGirl.create :round
      
      assert_equal r1, Round.current
      
      r2 = FactoryGirl.create :round
      
      assert_equal r2, Round.current
    end
    
    should 'get the rounds since a given round' do
      r1 = FactoryGirl.create :round

      assert_equal 0, Round.since(r1)

      (1..5).each do |n|
        FactoryGirl.create :round
        assert_equal n, Round.since(r1)
      end
    end
  end
end
