class Reservation < ActiveRecord::Base
  has_many :equipment_models_reservations
  has_many :equipment_models, :through => :equipment_models_reservations
  has_and_belongs_to_many :equipment_objects
  belongs_to :reserver, :class_name => 'User'
  belongs_to :checkout_handler, :class_name => 'User'
  belongs_to :checkin_handler, :class_name => 'User'
  
  validates_presence_of :reserver
  validates_presence_of :start_date
  validates_presence_of :due_date
  validate :not_empty
  validate :not_in_past
  validate :start_date_before_due_date
  
  named_scope :currently_out, :conditions => ["checked_out IS NOT NULL and checked_in IS NULL"]
  named_scope :active, :conditions => ["checked_in IS NULL"]
  
  attr_accessible :reserver, :reserver_id, :checkout_handler, :checkout_handler_id, :checkin_handler, :checkin_handler_id, :start_date, :due_date, :checked_out, :checked_in, :equipment_object_ids
  
  def status
    #TODO: check this logic
    if checked_out.nil?
      "reserved"
    elsif checked_in.nil?
      due_date < Date.today ? "overdue" : "checked out"
    elsif !equipment_objects.empty?
      "partially returned"
    else
      "returned"
    end
  end
  
  def not_empty
    errors.add_to_base("A reservation must contain at least one item.") if self.equipment_models_reservations.empty?
  end
  
  def not_in_past
    errors.add_to_base("A reservation cannot be made in the past!") if self.due_date < Time.now.midnight
  end
  
  def start_date_before_due_date
    errors.add_to_base("A reservation's due date must come after its start date.") if self.due_date < self.start_date
  end
  
  def late_fee
    equipment_models_reservations.map{|item| item.quantity * item.equipment_model.late_fee}.sum.to_f
  end
  
  def equipment_list
    raw_text = ""
    self.equipment_models_reservations.each do |equipment_models_reservations|
      raw_text += "#{equipment_models_reservations.quantity} x #{equipment_models_reservations.equipment_model.name}\r\n"
    end
    raw_text
  end
  
  # def equipment_object_ids=(ids)
  #   ids.each do |id|
  #     equipment_objects << EquipmentObject.find(id)
  #   end
  # end
end