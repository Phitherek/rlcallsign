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
        @user = RemoteUser.find_by_callsign(params[:query])
        if !@user.nil? && @user.callsign_info.nil?
            @user = nil
        end
        if @user.nil?
            render json: {error: "notfound"}
        else
            render json: {info: {callsign: @user.callsign, name: @user.callsign_info.name, stationary_qth: @user.callsign_info.stationary_qth, stationary_qth_locator: @user.callsign_info.stationary_qth_locator, current_qth: (@user.callsign_info.current_qth.nil? || @user.callsign_info.current_qth.empty?) && (@user.callsign_info.current_qth_locator.nil? || @user.callsign_info.current_qth_locator.empty?) ? @user.callsign_info.stationary_qth : @user.callsign_info.current_qth, current_qth_locator: (@user.callsign_info.current_qth.nil? || @user.callsign_info.current_qth.empty?) && (@user.callsign_info.current_qth_locator.nil? || @user.callsign_info.current_qth_locator.empty?) ? @user.callsign_info.stationary_qth_locator : @user.callsign_info.current_qth_locator}}
        end
    end

    def update_current_qth
        if params[:token].nil? || params[:token].empty?
            render json: {error: "rlauthtokenrequired"}
        else
            res = HTTParty.post('https://rlauth.deira.phitherek.me/altapi/user_data', token: params[:token])
            res = JSON.parse(res.body)
            if !res['error'].nil?
                render json: {error: "rlauth_#{res['error']}"}
            else
                @user = RemoteUser.find_by_callsign(res['user']['callsign'])
                if @user.nil?
                    render json: {error: "unauthorized"}
                elsif @user.callsign_info.nil?
                    render json: {error: "nocallsigninfo"}
                else
                    @user.callsign_info.current_qth = params[:current_qth]
                    @user.callsign_info.current_qth_locator = params[:current_qth_locator]
                    if @user.callsign_info.save
                        render json: {success: "success"}
                    else
                        render json: {error: "validation"}
                    end
                end
            end
        end
    end
end