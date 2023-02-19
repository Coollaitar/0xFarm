import { Products } from './components/products';
import contents from './content';

export default function App() {
  return (
    <div className='App'>
      {contents.map((contents) => (
        <Products
          key={contents.id}
          image={contents.image}
          name={contents.name}
          price={contents.price}
          rating={contents.rating}
          location={contents.location}
          tokens={contents.totalTokens}
          area={contents.landArea}
        />
      ))}
    </div>
  );
}
