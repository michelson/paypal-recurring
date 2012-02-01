require "spec_helper"

describe PayPal::Recurring::Response::Payment do
  context "when successful" do
    use_vcr_cassette "payment/success"

    subject {
      ppr = PayPal::Recurring.new({
        :description => "Awesome - Monthly Subscription",
        :amount      => "9.00",
        :currency    => "USD",
        :payer_id    => "WTTS5KC2T46YU",
        :token       => "EC-7A593227AC789800N",
        :logo=>"http://judicialbeep.com/assets/logo-negro-f5e1c7990957c240bcde6115dbe6b2c1.png",
        :bg_color=>"CCCCCC",
        :brand_name=>"FOOBAR Store!"
      })
      ppr.request_payment
    }

    it { should be_valid }
    it { should be_completed }
    it { should be_approved }

    its(:errors) { should be_empty }
  end

  context "when failure" do
    use_vcr_cassette("payment/failure")
    subject { PayPal::Recurring.new.request_payment }

    it { should_not be_valid }
    it { should_not be_completed }
    it { should_not be_approved }

    its(:errors) { should have(1).items }
  end
end
