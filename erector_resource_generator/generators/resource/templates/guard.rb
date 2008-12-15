Guard::Guard.initialize(:<%= table_name %>, 
                 { :index => [:root], 
                   :show => [:root], 
                   :edit => [:root], 
                   :update => [:root], 
                   :new => [:root], 
                   :create => [:root], 
                   :destroy => [:root] })
