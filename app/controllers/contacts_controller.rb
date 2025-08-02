class ContactsController < ApplicationController



def index
    @contacts = Contact.all
end

def new
     @contact = Contact.new
end

def done

end




def create
    contact = Contact.new(contact_params)


    if contact.save!
      redirect_to :action => "done"
    else
      redirect_to :action => "new"
    end
end

  private
  def contact_params
    params.require(:contact).permit(:name, :mail, :title,:about)
  end
end


