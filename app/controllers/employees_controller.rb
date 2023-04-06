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
end
