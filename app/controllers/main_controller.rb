class MainController < ApplicationController

    before_filter :find_user
    before_filter :user_only, only: [:new, :create, :show, :edit, :update, :destroy]

    def index

    end

    def query
        @users = RemoteUser.like(params[:callsign_query]).with_info
    end

    def new

    end

    def create

    end

    def show

    end

    def edit

    end

    def update

    end

    def predestroy

    end

    def destroy

    end

    def omniauth_callback

    end

    def logout
        HTTParty.post("https://rlauth.deira.phitherek.me/oauth/revoke?token=#{@session.token}")
        @session.destroy
        session.delete('remote_session_token')
        redirect_to root_path
    end

    private

    def auth_hash
        request.env['omniauth.auth']
    end

    def find_user
        if session['remote_session_token'] != nil
            @session = RemoteSession.find_by_token(session['remote_session_token'])
            if !@session.nil?
                @user = @session.remote_user
                @check = JSON.parse(HTTParty.get("https://rlauth.deira.phitherek.me/api/user_data?access_token=#{@session.token}").body || "{}")
                if @check.include?("status") && @check["status"] == "failure"
                    session['remote_session_token'] = nil
                    redirect_to '/auth/rlauth' and return
                elsif @check.include?("user")
                    @user = RemoteUser.find_by_callsign(@check["user"]["callsign"])
                    if !@user.nil?
                        session['remote_session_token'] = @session.token
                    else
                        session['remote_session_token'] = nil
                    end
                end
            else
                @user = nil
            end
        else
            @user = nil
        end
    end

    def user_only
        redirect_to root_path unless !@user.nil?
    end
end
