site :nancy do |site_uid|
  2.times do |i|
    pdu "graphene-pdu#{i+5}" do |pdu_uid|
      vendor "Eaton Corporation"
      model ""
      sensors [
        {
          :power => {
            :per_outlets => true,
            :snmp => {
              :available => true,
              :total_oids => ["iso.3.6.1.4.1.534.6.6.7.5.5.1.3.0.1", "iso.3.6.1.4.1.534.6.6.7.5.5.1.3.0.2"],
              :unit => "W",
              :outlet_prefix_oid => "iso.3.6.1.4.1.534.6.6.7.6.5.1.3.0"
            }
          }
        }
      ]
    end
  end
end
