class MainController < ApplicationController

    before_filter :find_user
    before_filter :user_only, only: [:new, :create, :show, :edit, :update, :predestroy, :destroy, :logout]

    def index

    end

    def query
        @users = RemoteUser.like(params[:callsign_query]).with_info
    end

    def new
        if !@user.callsign_info.nil?
            flash[:error] = t("errors.info_already_entered")
            redirect_to edit_path
        end
        @info = CallsignInfo.new
    end

    def create
        if !@user.callsign_info.nil?
            flash[:error] = t("errors.info_already_entered")
            redirect_to edit_path
        end
        @info = CallsignInfo.create(info_params)
        if @info.new_record?
            flash[:error] = t("errors.error_while_saving") + ": " + @info.errors.full_messages.join(", ")
            redirect_to new_path
        else
            flash[:success] = t("success.info_created")
            redirect_to show_path
        end
    end

    def show
        if @user.callsign_info.nil?
            flash[:error] = t("errors.info_not_entered")
            redirect_to root_path
        end
    end

    def edit
        if @user.callsign_info.nil?
            flash[:error] = t("errors.info_not_entered")
            redirect_to new_path
        end
        @info = @user.callsign_info
    end

    def update
        if @user.callsign_info.nil?
            flash[:error] = t("errors.info_not_entered")
            redirect_to new_path
        end
        @info = @user.callsign_info
        if @info.update_attributes(info_params)
            flash[:success] = t("success.info_updated")
            redirect_to show_path
        else
            flash[:error] = t("errors.error_while_saving") + ": " + @info.errors.full_messages.join(", ")
            redirect_to edit_path
        end
    end

    def predestroy
        if @user.callsign_info.nil?
            flash[:error] = t("errors.info_not_entered")
            redirect_to root_path
        end
    end

    def destroy
        if @user.callsign_info.nil?
            flash[:error] = t("errors.info_not_entered")
            redirect_to root_path
        end
        if @user.callsign_info.destroy
            flash[:success] = t("success.info_destroyed")
            redirect_to root_path
        else
            flash[:error] = t("errors.error_while_destroying")
            redirect_to predestroy_path
        end
    end

    def omniauth_callback
        if !auth_hash.nil?
            @user = RemoteUser.find_by_callsign(auth_hash.info.callsign)
            if @user.nil?
                @user = RemoteUser.create(callsign: auth_hash.info.callsign, email: auth_hash.info.email)
                @user.reload
            end
            @session = RemoteSession.new
            @session.token = auth_hash.credentials.token
            @session.token_expires = Time.at(auth_hash.credentials.expires_at)
            @session.refresh_token = auth_hash.credentials.refresh_token
            @session.remote_user = @user
            @session.save!
            @user.save!
            session['remote_session_token'] = @session.token
        end
        redirect_to root_path
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

    def info_params
        params.require(:callsign_info).permit(:name, :stationary_qth, :stationary_qth_locator, :current_qth, :current_qth_locator, :remote_user_id)
    end
end
