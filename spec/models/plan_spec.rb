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

  it 'it applies tax if charge taxes is true' do
    plan = Plan.new(price_per_cycle_in_cents: 12000, tax_rate: 10, charge_taxes: true)

    expect(plan.price).to eq(132)
  end

  it 'it does not apply tax if charge taxes is false' do
    plan = Plan.new(price_per_cycle_in_cents: 12000, tax_rate: 10, charge_taxes: nil)

    expect(plan.price).to eq(120)
  end

  it 'it does not apply tax if charge taxes is not set' do
    plan = Plan.new(price_per_cycle_in_cents: 12000)

    expect(plan.price).to eq(120)
  end
end
