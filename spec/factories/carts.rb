FactoryGirl.define do
  factory :cart do
    reserver_id { FactoryGirl.create(:user).id }
    start_date { Date.today }
    due_date { Date.tomorrow }
    items []

    factory :cart_with_items do
      items { [ FactoryGirl.create(:cart_reservation).id ]}
    end

    factory :invalid_cart do
      items { [ FactoryGirl.create(:invalid_cart_reservation).id,
                FactoryGirl.create(:invalid_cart_reservation).id ]}
    end
  end
end
