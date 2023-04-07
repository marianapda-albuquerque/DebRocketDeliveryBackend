class EmployeesController < ApplicationController
  def index
    @elements = Employee.all
  end

  def show
    @element = Employee.find(params[:id])
  end

  def destroy
    if Employee.delete(params[:id]) > 0
      flash[:notice] = "Successfully deleted."
    else
      flash[:notice] = "Failed to delete."
    end
    redirect_to employees_url
  end

  def edit
    @element = Employee.find(params[:id])
  end

  def update
    ActiveRecord::Base.transaction do
      @element = Employee.find(params[:id])
    
      address = Address.find_or_create_by!(street_address: employee_params[:street_address], city: employee_params[:city], postal_code: employee_params[:postal_code])

      response = @element.update!(address_id: address.id, email: employee_params[:email], phone: employee_params[:phone])
    end

    if response
      redirect_to(@element)
    else
      render "edit"
    end
  end

  def employee_params
    params.require(:employee).permit(:email, :phone, :street_address, :city, :postal_code)
  end
end
