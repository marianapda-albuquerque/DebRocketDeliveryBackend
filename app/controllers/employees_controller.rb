class EmployeesController < ApplicationController
  def index
    @elements = Employee.all
  end

  def show
    @element = Employee.find(params[:id])
  end

  def new
    render
  end

  def create
    m = ''
    transaction_succeeded = false

    ActiveRecord::Base.transaction do
      user = User.where(email: employee_params[:user_email]).first
      
      if !user 
        m = 'User not found.'
        raise ActiveRecord::Rollback
      end

      address = Address.find_or_create_by!(street_address: employee_params[:street_address], city: employee_params[:city], postal_code: employee_params[:postal_code])

      employee = Employee.where(user_id: user.id).first
      
      if employee
        m = 'User email already in use.'
        raise ActiveRecord::Rollback
      end

      response = Employee.create(user_id: user.id, address_id: address.id, email: employee_params[:email], phone: employee_params[:phone])
      
      if !response
        m = 'Failed to create employee.'
        raise ActiveRecord::Rollback
      end

      transaction_succeeded = true
    end

    if transaction_succeeded
      flash[:notice] = "Employee created!"
      redirect_to employees_url
    else
      flash[:notice] = m
      redirect_to new_employee_path
    end
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
    m = ''
    transaction_succeeded = false

    ActiveRecord::Base.transaction do
      @element = Employee.find(params[:id])
    
      address = Address.find_or_create_by!(street_address: employee_params[:street_address], city: employee_params[:city], postal_code: employee_params[:postal_code])

      response = @element.update(address_id: address.id, email: employee_params[:email], phone: employee_params[:phone])

      if !response
        m = 'Failed to update employee.'
        raise ActiveRecord::Rollback
      end

      transaction_succeeded = true
    end

    if transaction_succeeded
      flash[:notice] = "Employee updated!"
      redirect_to(@element)
    else
      flash[:notice] = m
      redirect_to(@element)
    end
  end

  def employee_params
    params.require(:employee).permit(:user_email, :email, :phone, :street_address, :city, :postal_code)
  end
end
