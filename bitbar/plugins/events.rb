#!/usr/bin/env ruby

require 'time'
require "ostruct"

events = `/usr/local/bin/icalbuddy -f -npn -nc -iep "title,datetime" -ps "| : |" -po "datetime,title" -tf "%H:%M" -eed -n eventsToday`

def parse_event(string)
  out = /(?<time>\d+:\d\d).*\s:\s(?<title>.*)$/.match(string.force_encoding("iso-8859-1"))
  return nil unless out

  event_time = Time.parse(out[:time])
  event_title = out[:title]
  seconds_until = event_time - Time.now
  minutes_until = seconds_until > 60 ? (seconds_until/60).floor : 0
  hours_until = minutes_until && minutes_until > 60 ? (minutes_until/60).floor : 0

  OpenStruct.new(
    time: event_time,
    title: event_title,
    seconds_until: seconds_until,
    minutes_until: minutes_until,
    hours_until: hours_until
  )
end

if events
  events = events.lines
  next_event = events.find do |event|
    parsed = parse_event(event)

    parsed.time > Time.now
  end

  if next_event
    next_event = parse_event(next_event)

    hours_text = "#{next_event.hours_until}h " if next_event.hours_until > 0
    minutes_text = next_event.hours_until > 0 ? "#{next_event.minutes_until%(next_event.hours_until*60)}m " : "#{next_event.minutes_until}m " if next_event.minutes_until > 0
    seconds_text = next_event.minutes_until > 0 ? "#{(next_event.seconds_until%(next_event.minutes_until*60)).floor}s " : "#{next_event.seconds_until.floor}s "

    puts "#{hours_text}#{minutes_text}#{seconds_text}until #{next_event.title}"
  else
    puts "No upcoming events"
  end
else
  puts "No upcoming events"
end

