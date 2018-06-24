require 'fcm'
require 'grocer'

class NotificationJob < ApplicationJob
  queue_as :default

    def perform(device_type, device_token, msg, type, object_id)
    	if (device_type == "ios")
        # p "=APPLE====TYPE====#{device_type}=========TOKEN_DEV======#{device_token}==========MSG======#{msg}========TYPE======#{type}================"

  		    pusher = Grocer.pusher(
  		    certificate: Rails.root.join('spotpotodistribution.pem'),# required
  		    passphrase:  "spot",              # optional
  		    gateway:     "gateway.push.apple.com", # optional; See note below.
  		    # gateway:     "gateway.sandbox.push.apple.com", # optional; See note below.
  		    port:        2195,                     # optional
  			  retries:     3                         # optional
  			)
  			case(type)
  				when type = "like"
  					notification = Grocer::Notification.new(
  		    	device_token: "#{device_token}",
            alert:            msg,
            custom:         {:NT => "like", :id => "#{object_id}" },
            sound:             "siren.aiff",         # optional

  					badge: 1
  					  	)
  					sent = pusher.push(notification)
            # p "======RESPONSE=============================#{sent}======================"
  					return

  				when type = "comment"
  					notification = Grocer::Notification.new(
  						device_token: "#{device_token}",
              alert:            msg,
              custom:         {:NT => "comment", :id => "#{object_id}" },
  						badge: 1
  						)
  						sent = pusher.push(notification)
              # p "======RESPONSE=============================#{sent}======================"

  						return

  				when type = "reply"
  					notification = Grocer::Notification.new(
  						device_token: "#{device_token}",
              alert:            msg,
              custom:         {:NT => "reply", :id => "#{object_id}" },
  						badge: 1
  						)
  						sent = pusher.push(notification)
              # p "======RESPONSE=============================#{sent}======================"

  						return

          when type = "tag"
  					notification = Grocer::Notification.new(
  						device_token: "#{device_token}",
              alert:            msg,
              custom:         {:NT => "tag", :id => "#{object_id}" },
  						badge: 1
  						)
  						sent = pusher.push(notification)
              # p "======RESPONSE=============================#{sent}======================"


  						return
			end

		else
       p "=ANDROID====TYPE====#{device_type}=========TOKEN_DEV======#{device_token}==========MSG======#{msg}========TYPE======#{type}================"

 		fcm = FCM.new("AAAA_431Lcs:APA91bHqhUI-SLOx0g79usQ147m5-IUOerfEmfqbl_hmmiBCGJMKY7bJuib6Dgo-6RkXgdGIkPXSt168TkbuGlbJqQW65lVJwPp1oZv_H5Gra52GMX2oHlJUfy97CMb4LlNjXWsgj6Gm")
	        registration_ids= ["#{device_token}"]
	        options = {
	          'data' => {
	            'message' =>['alert' => "#{msg}",'badge' => 1, 'id' => "#{object_id}",'type' => "#{type}"]
	          },
	          "time_to_live" => 108,
	          "delay_while_idle" => true,
	          "collapse_key" => 'updated_state'
	        }
	        response = fcm.send_notification(registration_ids,options)
          p "======RESPONSE=============================#{response.inspect}======================"


		end
	end
end
