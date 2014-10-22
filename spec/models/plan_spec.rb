require 'spec_helper'

describe Plan, '#attributes' do
  it 'includes has_extras=true if plan has extras' do
    plan = Plan.new(extras: [Extra.new])

    expect(plan.attributes[:has_extras]).to be_true
  end

  it 'includes has_extras=false if plan has no extras' do
    plan = Plan.new(extras: [])

    expect(plan.attributes[:has_extras]).to be_false
  end
end
