class StoresController < ApplicationController
    before_action :logged_in_user, only: [:create, :update_store, :destroy, :my_store]

    def index
            @stores = Store.all.order('created_at ASC')
                .paginate(page: params[:page], per_page: 6)
    end

    def my_store
            @stores = Store.where(user_id: current_user.id)
                .order('name ASC')
                .paginate(page: params[:page], per_page: 6)
    end

    def create
        @store = Store.new(store_params)
        if @store.save
            flash[:info] = "作成しました"
            redirect_to :back
        else
            flash[:danger] = @store.errors.full_messages.join(" & ")
            redirect_to :back
        end
    end

    def show
        @store = Store.find_by(id: params[:id])
        if @store == nil
            not_found
        end
    end

    def update_store
        @store = Store.find(store_params[:id])
        if @store.update_attributes(store_params)
            flash[:success] = "更新しました"
            redirect_to :back
        else
            render 'edit'
        end
    end

    def destroy
        @store = Store.find(params[:id]).destroy
        flash[:success] = "削除しました"

        if @store.destroy
            redirect_to my_store_path
        end
    end

    private
        def store_params
            params.require(:store).permit(:name, :address, :user_id, :id)
        end

end
