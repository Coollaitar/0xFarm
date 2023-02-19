import {
  FaShoppingCart,
  FaRegBookmark,
  FaStar,
  FaEthereum,
} from 'react-icons/fa';
import Button from 'react-bootstrap/Button';
export function Products(props) {
  return (
    <div className='productList'>
      <div key={props.id} className='productCard'>
        <img src={props.image} alt='product-img' className='productImage'></img>

        <FaShoppingCart className={'productCard__cart'} />
        <FaRegBookmark className={'productCard__wishlist'} />
        <FaEthereum className={'productCard__fastSelling'} />

        <div className='productCard__content'>
          <h3 className='productName'>{props.name}</h3>
          <h3 className='productName'>Location: {props.location}</h3>
          <div className='displayStack__1'>
            <div className='productPrice'>${props.price} per sqft</div>
            <div className='productSales'>{props.tokens} tokens left</div>
          </div>
          <div className='displayStack__2'>
            <div className='productRating'>
              {[...Array(props.rating)].map((index) => (
                <FaStar id={index + 1} key={index} />
              ))}
            </div>

            <Button className='button'>
              <span>Buy</span>
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
}
