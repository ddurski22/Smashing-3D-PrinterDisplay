require 'json'
require 'net/http'

SCHEDULER.every '5s', :first_in => 0 do |job|

  host = 'http://10.76.100.155/'
  host2 = 'http://10.76.100.44/'

  url = URI.join(host, 'api/v1/printer')
  
  response = Net::HTTP.get_response(url)
  
  if response.code.to_i == 200
    data = JSON.parse(response.body)
	
	temps=Hash.new

    ex1temp = data['heads'][0]['extruders'][0]['hotend']['temperature']['current']
    #send_event('ex1temp', { temperature: ex1temp })

    ex2temp = data['heads'][0]['extruders'][1]['hotend']['temperature']['current']
    #send_event('ex2temp', { temperature: ex2temp })

    bedtemp = data['bed']['temperature']['current']
    #send_event('bedtemp', { temperature: bedtemp })

	temps['temp 1']= bedtemp
	temps['temp 2']= ex1temp
	temps['temp 3']= ex2temp
	send_event(temps,temp)
  else
    temp = Hash.new
    temp['temperature'] = ''
    send_event('temp 2', temp)
    send_event('temp 3', temp)
    send_event('temp 1', temp)
  end

  url = URI.join(host, 'api/v1/print_job')
  response = Net::HTTP.get_response(url)
  
  if response.code.to_i == 200 
    data = JSON.parse(response.body)
	send_event('progress', { value: (data['progress'] * 100).to_i })

    status = data['state']
	status_str = status.split('_').map!(&:capitalize).join(' ')
	send_event('status', { text: status_str })
	
    job_name = data['name']
    job_name_str = job_name.split('_').join(' ')
    send_event('job_name', { text: job_name_str })

    remaining = Hash.new

    total_sec = data['time_total'].to_i - data['time_elapsed'].to_i

    seconds_in_day = 60 * 60 * 24
    remaining_days = (total_sec / seconds_in_day).to_i
    remaining['days'] = remaining_days

    total_sec %= seconds_in_day

    seconds_in_hour = 60 * 60
    remaining_hours = (total_sec / seconds_in_hour).to_i
    remaining['hours'] = remaining_hours

    total_sec %= seconds_in_hour

    seconds_in_minute = 60
    remaining_minutes = (total_sec / seconds_in_minute).to_i
    remaining['minutes'] = remaining_minutes

    remaining_seconds = total_sec % seconds_in_minute
    remaining['seconds'] = remaining_seconds

    send_event('remaining', remaining)


    elapsed = Hash.new

    total_sec = data['time_elapsed'].to_i

    elapsed['days'] = (total_sec / seconds_in_day).to_i
    total_sec %= seconds_in_day

    elapsed['hours'] = (total_sec / seconds_in_hour).to_i
    total_sec %= seconds_in_hour

    elapsed['minutes'] = (total_sec / seconds_in_minute).to_i

    elapsed['seconds'] = total_sec % seconds_in_minute

    send_event('elapsed', elapsed)
	
	





  else
    send_event('progress', { value: 0 })
    send_event('status', { text: 'Idle' })
    send_event('job_name', { text: 'N/A' })
    remaining = Hash.new
    remaining['days'] = 0
    remaining['hours'] = 0
    remaining['minutes'] = 0
    remaining['seconds'] = 0
    send_event('remaining', remaining)
    send_event('elapsed', remaining)
  end
  
  url = URI.join(host2, 'api/v1/print_job')
  response = Net::HTTP.get_response(url)
  
  if response.code.to_i == 200 
    data = JSON.parse(response.body)
	send_event('progress', { value: (data['progress'] * 100).to_i })

    status = data['state']
	status_str = status.split('_').map!(&:capitalize).join(' ')
	send_event('status2', { text: status_str })
	
    job_name = data['name']
    job_name_str = job_name.split('_').join(' ')
    send_event('job_name', { text: job_name_str })

    remaining = Hash.new

    total_sec = data['time_total'].to_i - data['time_elapsed'].to_i

    seconds_in_day = 60 * 60 * 24
    remaining_days = (total_sec / seconds_in_day).to_i
    remaining['days'] = remaining_days

    total_sec %= seconds_in_day

    seconds_in_hour = 60 * 60
    remaining_hours = (total_sec / seconds_in_hour).to_i
    remaining['hours'] = remaining_hours

    total_sec %= seconds_in_hour

    seconds_in_minute = 60
    remaining_minutes = (total_sec / seconds_in_minute).to_i
    remaining['minutes'] = remaining_minutes

    remaining_seconds = total_sec % seconds_in_minute
    remaining['seconds'] = remaining_seconds

    send_event('remaining2', remaining)


    elapsed = Hash.new

    total_sec = data['time_elapsed'].to_i

    elapsed['days'] = (total_sec / seconds_in_day).to_i
    total_sec %= seconds_in_day

    elapsed['hours'] = (total_sec / seconds_in_hour).to_i
    total_sec %= seconds_in_hour

    elapsed['minutes'] = (total_sec / seconds_in_minute).to_i

    elapsed['seconds'] = total_sec % seconds_in_minute

    send_event('elapsed2', elapsed)
	





  else
    send_event('progress2', { value: 0 })
    send_event('status2', { text: 'Idle' })
    send_event('job_name2', { text: 'N/A' })
    remaining = Hash.new
    remaining['days'] = 0
    remaining['hours'] = 0
    remaining['minutes'] = 0
    remaining['seconds'] = 0
    send_event('remaining2', remaining)
    send_event('elapsed2', remaining)
   end
	
	url = URI.join(host2, 'api/v1/printer')
  
  response = Net::HTTP.get_response(url)
  
  if response.code.to_i == 200
    data = JSON.parse(response.body)
	
	
	#ex1temp = data['heads'][0]['extruders'][0]['hotend']['temperature']['current']
    #send_event('ex1temp', { temperature: ex1temp })

    #ex2temp = data['heads'][0]['extruders'][1]['hotend']['temperature']['current']
    #send_event('ex2temp', { temperature: ex2temp })
	
	
    bedtemp = data['bed']['temperature']['current']
    send_event('bedtemp2', { temperature: bedtemp })

  else
    temp = Hash.new
    temp['temperature'] = ''
    #send_event('ex1temp', temp)
    #send_event('ex2temp', temp)
    send_event('bedtemp2', temp)
  end

	
	
  
  
end
