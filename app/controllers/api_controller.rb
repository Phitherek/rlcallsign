class ApiController < ApplicationController
    protect_from_forgery with: :null_session

    def query
        us = RemoteUser.like(params[:query]).with_info.order(:callsign)
        if us.empty?
            render json: {error: "empty"}
        else
            @content = []
            us.each do |u|
                @content << {callsign: u.callsign, name: u.callsign_info.name, stationary_qth: u.callsign_info.stationary_qth, stationary_qth_locator: u.callsign_info.stationary_qth_locator, current_qth: (u.callsign_info.current_qth.nil? || u.callsign_info.current_qth.empty?) && (u.callsign_info.current_qth_locator.nil? || u.callsign_info.current_qth_locator.empty?) ? u.callsign_info.stationary_qth : u.callsign_info.current_qth, current_qth_locator: (u.callsign_info.current_qth.nil? || u.callsign_info.current_qth.empty?) && (u.callsign_info.current_qth_locator.nil? || u.callsign_info.current_qth_locator.empty?) ? u.callsign_info.stationary_qth_locator : u.callsign_info.current_qth_locator}
            end
            render json: {infos: @content.as_json}
        end
    end

    def specific_query
        u = RemoteUser.find_by_callsign(params[:query])
        if !u.nil? && u.callsign_info.nil?
            u = nil
        end
        if u.nil?
            render json: {error: "notfound"}
        else
            render json: {info: {callsign: @user.callsign, name: @user.callsign_info.name, stationary_qth: @user.callsign_info.stationary_qth, stationary_qth_locator: @user.callsign_info.stationary_qth_locator, current_qth: (@user.callsign_info.current_qth.nil? || @user.callsign_info.current_qth.empty?) && (@user.callsign_info.current_qth_locator.nil? || @user.callsign_info.current_qth_locator.empty?) ? @user.callsign_info.stationary_qth : @user.callsign_info.current_qth, current_qth_locator: (@user.callsign_info.current_qth.nil? || @user.callsign_info.current_qth.empty?) && (@user.callsign_info.current_qth_locator.nil? || @user.callsign_info.current_qth_locator.empty?) ? @user.callsign_info.stationary_qth_locator : @user.callsign_info.current_qth_locator}}
        end
    end
end