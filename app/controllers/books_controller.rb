class BooksController < ApplicationController
  before_action :authenticate_user!

  def index
    @books = Book.all
    @hash = Gmaps4rails.build_markers(@books) do |book, marker|
      marker.lat book.latitude
      marker.lng book.longitude
    end
  end

  def new
    @book = Book.new
  end

  def create
    @book = current_user.books.new(book_params)
    if @book.valid?
      if @book.save
        redirect_to @book
      end
    else
      redirect_to new_book_path
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])

    if @book.update(book_params)
      redirect_to @book
    else
      render 'edit'
    end
  end

  def show
    @book = Book.find(params[:id])
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy

    redirect_to books_path
  end

  private
    def book_params
      params.require(:book).permit(:title, :content, :price, :city, :avatar)
    end
end
